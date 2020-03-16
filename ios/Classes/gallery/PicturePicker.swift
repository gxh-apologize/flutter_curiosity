import Foundation
import Flutter
import UIKit
import AssetsLibrary

class PicturePicker: NSObject, TZImagePickerControllerDelegate {
    
    class func openPicker(_ arguments: [AnyHashable : Any], _ viewController: UIViewController, _ result: FlutterResult) {
        print("LogInfo\(arguments)")
        let maxSelectNum = (arguments["maxSelectNum"] as! NSNumber).intValue
        let minSelectNum = (arguments["minSelectNum"] as! NSNumber).intValue
        let imageSpanCount = (arguments["imageSpanCount"] as! NSNumber).intValue
        let selectionMode = (arguments["selectionMode"] as! NSNumber).intValue
        let minimumCompressSize = (arguments["minimumCompressSize"] as! NSNumber).intValue
        let cropW = (arguments["cropW"] as! NSNumber).intValue
        let cropH = (arguments["cropH"] as! NSNumber).intValue
        let cropCompressQuality = (arguments["cropCompressQuality"] as! NSNumber).intValue
        let videoMaxSecond = (arguments["videoMaxSecond"] as! NSNumber).intValue
        let videoMinSecond = (arguments["videoMinSecond"] as! NSNumber).intValue
        let recordVideoSecond = (arguments["recordVideoSecond"] as! NSNumber).intValue
        let pickerSelectType = (arguments["pickerSelectType"] as! NSNumber).intValue
        let circleCropRadius = (arguments["circleCropRadius"] as! NSNumber).intValue
        let previewImage = (arguments["previewImage"] as! NSNumber).boolValue
        let previewVideo = (arguments["previewVideo"] as! NSNumber).boolValue
        let isZoomAnim = (arguments["isZoomAnim"] as! NSNumber).boolValue
        let isCamera = (arguments["isCamera"] as! NSNumber).boolValue
        let enableCrop = (arguments["enableCrop"] as! NSNumber).boolValue
        let compress = (arguments["compress"] as! NSNumber).boolValue
        let hideBottomControls = (arguments["hideBottomControls"] as! NSNumber).boolValue
        let freeStyleCropEnabled = (arguments["freeStyleCropEnabled"] as! NSNumber).boolValue
        let showCropCircle = (arguments["showCropCircle"] as! NSNumber).boolValue
        let showCropFrame = (arguments["showCropFrame"] as! NSNumber).boolValue
        let showCropGrid = (arguments["showCropGrid"] as! NSNumber).boolValue
        let openClickSound = (arguments["openClickSound"] as! NSNumber).boolValue
        let isGif = (arguments["isGif"] as! NSNumber).boolValue
        let scaleAspectFillCrop = (arguments["scaleAspectFillCrop"] as! NSNumber).boolValue
        let originalPhoto = (arguments["originalPhoto"] as! NSNumber).boolValue
        
        let picker = TZImagePickerController(maxImagesCount: maxSelectNum, delegate: nil)!
        picker.maxImagesCount = maxSelectNum
        picker.minImagesCount = minSelectNum
        picker.allowPickingGif = isGif
        picker.allowCrop = enableCrop
        if pickerSelectType == 1 {
            picker.allowPickingImage = true
            picker.allowTakePicture = isCamera
            picker.allowPickingVideo = false
            picker.allowTakeVideo = false
        } else if pickerSelectType == 2 {
            picker.allowPickingVideo = true
            picker.allowTakeVideo = isCamera
            picker.allowPickingImage = false
            picker.allowTakePicture = false
        } else {
            picker.allowPickingImage = true
            picker.allowPickingVideo = true
            picker.allowTakePicture = isCamera
            picker.allowTakeVideo = isCamera
        }
        
        if isCamera && picker.allowTakeVideo {
            picker.videoMaximumDuration = TimeInterval(videoMaxSecond)
        }
        picker.allowPreview = previewImage
        picker.allowPickingOriginalPhoto = originalPhoto
        picker.showPhotoCannotSelectLayer = true
        if selectionMode == 1 {
            // 单选模式
            picker.showSelectBtn = false
            picker.allowCrop = enableCrop
            if enableCrop {
                picker.scaleAspectFillCrop = scaleAspectFillCrop //是否图片等比缩放填充cropRect区域
                if showCropCircle {
                    picker.needCircleCrop = showCropCircle //圆形裁剪
                    picker.circleCropRadius = circleCropRadius //圆形半径
                } else {
                    let x = (Int(UIScreen.main.bounds.size.width) - cropW) / 2
                    let y = (Int(UIScreen.main.bounds.size.height) - cropH) / 2
                    picker.cropRect = CGRect(x: x, y: y, width: cropW, height: cropH)
                }
            }
        }
        let manager = TZImageManager()
        weak var weakPicker = picker
        picker.didFinishPickingPhotosHandle = { photos, assets, isSelectOriginalPhoto in
            weakPicker?.showProgressHUD()
            if selectionMode == 1 && enableCrop {
                result(PicturePickerUtils.resultImage(photos![0], assets![0] as! PHAsset, CGFloat(cropCompressQuality)))
            } else {
                var selectedPhotos: [Any]
                (assets! as NSArray).enumerateObjects({ (phAsset, idx, stop) in
                    let asset = phAsset as! PHAsset
                    if asset.mediaType == .video {
                        manager.getVideoOutputPath(with: asset, presetName: AVAssetExportPresetHighestQuality, success: { outputPath in
                            selectedPhotos.append(PicturePickerUtils.resultVideo(outputPath!, asset, CGFloat(cropCompressQuality)) as Any)
                            if selectedPhotos.count == assets!.count {
                                result(selectedPhotos)
                            }
                            if idx + 1 == assets!.count && selectedPhotos.count != assets!.count {
                                result("fail")
                            }
                        }, failure: { errorMessage, error in
                            
                        })
                    }else{
                        let isGIF = manager.getAssetType(asset) == TZAssetModelMediaTypePhotoGif
                        if isGIF || isSelectOriginalPhoto {
                            manager.requestImageData(for: asset, completion: { imageData, dataUTI, orientation, info in
                                selectedPhotos.append(PicturePickerUtils.resultOriginalPhotoData(imageData!, asset, isGIF, CGFloat(cropCompressQuality)) as Any)
                                if selectedPhotos.count == assets!.count {
                                    result(selectedPhotos)
                                }
                                if idx + 1 == assets!.count && selectedPhotos.count != assets!.count {
                                    result("fail")
                                }
                            }, progressHandler: { progress, error, stop, info in
                                
                            })
                        } else {
                            selectedPhotos.append(PicturePickerUtils.resultImage(photos![idx], asset, CGFloat(cropCompressQuality)) as Any)
                            if selectedPhotos.count == assets!.count {
                                result(selectedPhotos)
                            }
                        }
                        
                    }
                })
            }
            weakPicker?.hideProgressHUD()
        }
        
        picker.didFinishPickingVideoHandle = { coverImage, asset in
            weakPicker!.showProgressHUD()
            manager.getVideoOutputPath(with: asset, presetName: AVAssetExportPresetHighestQuality, success: { outputPath in
                result([PicturePickerUtils.resultVideo(outputPath!, asset!,CGFloat(cropCompressQuality))])
                weakPicker!.dismiss(animated: true)
                weakPicker!.hideProgressHUD()
            }, failure: { errorMessage, error in
                //   print("视频导出失败:\(errorMessage),error:\(error)")
                result("视频导出失败")
                weakPicker!.dismiss(animated: true)
                weakPicker!.hideProgressHUD()
            })
        }
        picker.imagePickerControllerDidCancelHandle = {
            //        print("LogInfo\("cancel")")
            
            result("cancel")
        }
        picker.didFinishPickingGifImageHandle = { animatedImage, sourceAssets in
            //print("LogInfo\(sourceAssets)")
        }
        
        
        viewController.present(picker, animated: true)
        
    }
    class func openCamera(_ arguments: [AnyHashable : Any],_ viewController: UIViewController,_ result: FlutterResult) {
        //   print("LogInfo\(arguments)")
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == .restricted || authStatus == .denied {
            // 无相机权限 做一个友好的提示
            let alert = UIAlertView(title: "无法使用相机", message: "请在iPhone的 设置-隐私-相机 中允许访问相机", delegate: (self as! UIAlertViewDelegate), cancelButtonTitle: "取消", otherButtonTitles: "设置")
            alert.show()
        }else if authStatus == .notDetermined {
            // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted {
                    DispatchQueue.main.async(execute: {
                        self.openCamera(arguments, viewController, result)
                    })
                }
            })
            // 拍照之前还需要检查相册权限
        }else if PHPhotoLibrary.authorizationStatus().rawValue == 2 {
            // 已被拒绝，没有相册权限，将无法保存拍的照片
            let alert = UIAlertView(title: "无法访问相册", message: "请在iPhone的 设置-隐私-相册 中允许访问相册", delegate: (self as! UIAlertViewDelegate), cancelButtonTitle: "取消", otherButtonTitles: "设置")
            alert.show()
        } else if PHPhotoLibrary.authorizationStatus().rawValue == 0 {
            // 未请求过相册权限
            TZImageManager().requestAuthorization(completion: {
                self.openCamera(arguments, viewController, result)
            })
        }else {
            let picker = UIImagePickerController()
            let sourceType: UIImagePickerController.SourceType = .camera
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = sourceType
                viewController.present(picker, animated: true)
            } else {
                print("模拟器中无法打开照相机,请在真机中使用")
            }
        }
    }
    class func deleteCacheDirFile() {
        
    }
    
    
    func methodQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
}


import UIKit

extension ImagePicker {
    
    class Delegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var handler: Handler?
        var retainer: Any?
        
        init(retainer: Any, handler: @escaping Handler) {
            self.retainer = retainer // make retain cycle
            self.handler = handler
            super.init()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let key: UIImagePickerController.InfoKey = picker.allowsEditing ? .editedImage : .originalImage
            let image = info[key] as? UIImage
            dismiss(picker: picker, image: image)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(picker: picker)
        }
        
        func dismiss(picker: UIImagePickerController, image: UIImage? = nil) {
            handler?(image)
            handler = nil
            retainer = nil // release
            picker.dismiss(animated: true)
        }
    }
}

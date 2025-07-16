import { ImageChatViewModel } from "./ImageChatViewModel";

@ObservedV2
export class ImageCreationViewModel extends ImageChatViewModel {
  @Trace prompt: string = ''

  createImage() {
    super.createImage(this.prompt)
  }
}
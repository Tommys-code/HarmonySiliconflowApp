import SplashViewModel from '../viewmodel/SplashViewModel';
import { PersistenceV2, router } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Splash {
  @Local splash: SplashViewModel = PersistenceV2.connect(SplashViewModel, "Splash", () => new SplashViewModel())!;

  @Monitor("splash.nextPage")
  linkChange(monitor: IMonitor) {
    if (this.splash.nextPage) {
      router.replaceUrl({ url: this.splash.nextPage })
    }
  }

  build() {
    Stack() {
      Image($r('app.media.ic_silicon_flow'))
        .height(200)
        .objectFit(ImageFit.Cover)
    }.alignContent(Alignment.Center)
    .height('100%')
    .width('100%')
  }
}
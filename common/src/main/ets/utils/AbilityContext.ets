import { markConfig } from "@lidary/markdown";

export class AbilityContext {
  static initContext(context: Context) {
    AppStorage.setOrCreate('EntryAbilityContext', context);
    markConfig.setTheme({
      codeSpan: {
        backgroundColor:$r('app.color.container')
      }
    })
  }

  static getAbilityContext() {
    return AppStorage.get('EntryAbilityContext') as Context
  }
}
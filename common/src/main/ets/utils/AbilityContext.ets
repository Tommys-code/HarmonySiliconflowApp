export class AbilityContext {
  static initContext(context: Context) {
    AppStorage.setOrCreate('EntryAbilityContext', context);
  }

  static getAbilityContext() {
    return AppStorage.get('EntryAbilityContext') as Context
  }
}
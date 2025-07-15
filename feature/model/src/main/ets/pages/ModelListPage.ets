import { ImageStyle, ListDataSource, navigationTitle } from 'common'
import { ModelStore, TextAIModel } from 'common/src/main/ets/datastore/ModelStore'

@ComponentV2
struct ModelListPage {
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack()
  private modelList: ListDataSource<TextAIModel> = new ListDataSource()
  @Local private currentModel: TextAIModel = ModelStore.getInstance().getCurrentModel()

  aboutToAppear(): void {
    this.modelList.setNewData(ModelStore.getInstance().modelList)
    this.currentModel = ModelStore.getInstance().getCurrentModel()
  }

  private selectedItem(item: TextAIModel) {
    ModelStore.getInstance().changeModel(item)
    this.pageStack.pop(item)
  }

  build() {
    NavDestination() {
      List() {
        LazyForEach(this.modelList, (item: TextAIModel) => {
          ListItem() {
            Column() {
              Row() {
                Text(item.model).layoutWeight(1)
                if (item === this.currentModel) {
                  Image($r('[common].media.ic_check'))
                    .attributeModifier(ImageStyle.Small)
                }
              }
              .width('100%')
              .padding({
                left: 24,
                right: 24,
                top: 20,
                bottom: 20
              })
              .backgroundColor(item === this.currentModel ? $r('[common].color.background_l1') :
              $r('[common].color.transparent'))

              Divider().strokeWidth(0.5).margin({ left: 12, right: 12 })
            }
          }.onClick(() => {
            this.selectedItem(item)
          })
        })
      }.width('100%').height('100%')
    }
    .title(navigationTitle('', () => this.pageStack.pop()))
    .hideBackButton(true)
  }
}

@Builder
export function ModelListPageBuilder() {
  ModelListPage();
}
export function getSessionListBackgroundColor(itemId: number, currentId?: number): ResourceStr {
  if (currentId == itemId) {
    return $r('[common].color.container')
  } else {
    return $r('[common].color.transparent')
  }
}
export function dealWithApiKey(key: string) {
  if (key.length <= 8) {
    return key
  }
  return key.substring(0, 4) + '*'.repeat(8) + key.substring(key.length - 4);
}

export function formatPriceSimple(amount: number): string {
  if (Number.isInteger(amount)) {
    return `¥ ${Math.floor(amount)}`;
  } else {
    return `¥ ${amount}`;
  }
}
export interface ImageGenerationsResponse {
  images: ImageUrl[]
  seed: number,
}

export interface ImageUrl {
  url: string,
}
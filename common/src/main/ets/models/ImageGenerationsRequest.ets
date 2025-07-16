import { ImageCreationOptions } from "../datastore/SettingDataStore"

export interface ImageGenerationsRequest {
  model: string
  prompt: string
  image_size: string
  batch_size: number
  num_inference_steps: number
  guidance_scale: number
  image?: string
}

export function createImageGenerationsRequest(prompt: string, options: ImageCreationOptions): ImageGenerationsRequest {
  return {
    model: 'Kwai-Kolors/Kolors',
    prompt: prompt,
    image_size: options.ratio.value,
    batch_size: options.batchSize,
    num_inference_steps: 20,
    guidance_scale: 7.5
  }
}
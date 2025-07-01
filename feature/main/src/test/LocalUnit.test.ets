import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { logger } from 'common';

export default function localUnitTest() {
  describe('localUnitTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('assertContain', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    });
  });

  describe('test',()=>{
    it("assertContain", 0, () => {
        let data = 'data: {"id":"0197c49d02bdb0322c5c7400faa12267","object":"chat.completion.chunk","created":1751350313,"model":"Qwen/Qwen3-8B","choices":[{"index":0,"delta":{"content":" id","reasoning_content":null,"role":"assistant"},"finish_reason":null}],"system_fingerprint":"","usage":{"prompt_tokens":9,"completion_tokens":339,"total_tokens":348,"completion_tokens_details":{"reasoning_tokens":237}}}\n' +
          '\n' +
          'data: {"id":"0197c49d02bdb0322c5c7400faa12267","object":"chat.completion.chunk","created":1751350313,"model":"Qwen/Qwen3-8B","choices":[{"index":0,"delta":{"content":" is","reasoning_content":null,"role":"assistant"},"finish_reason":null}],"system_fingerprint":"","usage":{"prompt_tokens":9,"completion_tokens":340,"total_tokens":349,"completion_tokens_details":{"reasoning_tokens":237}}}\n'
        let value = data.split('data:')
        logger.debug(value.length.toString())
    })
  })
}
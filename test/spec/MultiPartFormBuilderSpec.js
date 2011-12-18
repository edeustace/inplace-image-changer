
  describe("Player", function() {
    var formBuilder;
    formBuilder = null;
    beforeEach(function() {
      formBuilder = new com.ee.MultipartFormBuilder("--boundary--");
      return null;
    });
    it("is constructed", function() {
      expect(formBuilder).toNotBe(null);
      return null;
    });
    return it("returns the correct content", function() {
      var expected, fileParams, out, params;
      expected = "----boundary--\nContent-Disposition: form-data; name=\"param\"; filename=\"mock\" \nContent-Type: mocktype\n\n123456789\n----boundary----";
      params = null;
      fileParams = [
        {
          file: {
            name: "mock",
            type: "mocktype"
          },
          data: "123456789",
          paramName: "param"
        }
      ];
      out = formBuilder.buildMultipartFormBody(params, fileParams);
      console.log("expected: ");
      console.log(expected);
      console.log("out:");
      console.log(out);
      expect(out).toEqual(expected);
      return null;
    });
  });

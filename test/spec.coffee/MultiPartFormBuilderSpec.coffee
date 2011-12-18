describe "Player", ->
  formBuilder = null

  beforeEach ->
    formBuilder = new com.ee.MultipartFormBuilder("--boundary--")
    null

  it "is constructed", ->
    expect(formBuilder).toNotBe null
    null

  it "returns the correct content", ->
    params = 
      method : "_put"

    fileParams = [
      file : 
        name : "mock"
        type : "mocktype"
      data : "123456789"
      paramName : "param"
        
    ]

    out = formBuilder.buildMultipartFormBody params, fileParams

    expect(out.indexOf("""form-data; name="#{fileParams[0].paramName}"; """)).toNotBe(-1)
    expect(out.indexOf("""filename="#{fileParams[0].file.name}" """) ).toNotBe -1
    expect(out.indexOf("""#{fileParams[0].data}""") ).toNotBe -1
    
    # normal params
    expect(out.indexOf("""form-data name='method'""")).toNotBe(-1)
    # TODO: looks like crlf are being corrupted.
    #expect(out).toEqual expected
    null

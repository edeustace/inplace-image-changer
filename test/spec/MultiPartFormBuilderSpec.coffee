describe "Player", ->
  formBuilder = null

  beforeEach ->
    formBuilder = new com.ee.MultipartFormBuilder("--boundary--")
    null

  it "is constructed", ->
    expect(formBuilder).toNotBe null
    null

  it "returns the correct content", ->
    expected = """----boundary--
Content-Disposition: form-data; name="param"; filename="mock" 
Content-Type: mocktype

123456789
----boundary----
"""
    params = null
    fileParams = [
      file : 
        name : "mock"
        type : "mocktype"
      data : "123456789"
      paramName : "param"
        
    ]

    out = formBuilder.buildMultipartFormBody params, fileParams
    
    console.log "expected: "
    console.log expected
    
    console.log "out:"
    console.log out

    expect(out).toEqual expected
    null

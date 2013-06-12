#= require spec_helper

describe "Entities.CodeModel", ->
  it "sets id to fullName", ->
    console.log SocketAdapter
    mod = new Demo.Entities.CodeModel fullName: "Henry"
    mod.get('id').should.equal mod.get('fullName')

  describe "CodeModel#fetch", ->
    it "fetches the model", (finished) ->
      mod = new Demo.Entities.CodeModel fullName: "M::A"
      mod.fetch().done (v) ->
        finished()

    it "errors when no matching model is found", (finished) ->
      mod = new Demo.Entities.CodeModel fullName: "Z"
      mod.fetch().fail (v) ->
        finished()

    it "returns the correct model", ->
      mod = new Demo.Entities.CodeModel fullName: "M::A"
      mod.fetch().done (v) ->
        v.id.should.equal "M::A"

  describe "CodeModel#save", ->
    it "saves the model", (finished) ->
      mod = new Demo.Entities.CodeModel fullName: "M::A"
      mod.fetch().then((v) -> mod.save()).done (v) ->
        finished()

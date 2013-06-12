#= require spec_helper

describe "Entities.RubyModule", ->
  it "sets id to fullName", ->
    mod = new Demo.Entities.RubyModule fullName: "Henry"
    mod.get('id').should.equal mod.get('fullName')

  it "deals with nested data", ->
    mod = new Demo.Entities.RubyModule
      fullName: "Henry"
      children: [{ fullName: "Carl" }, { fullName: "John" }]

    mod.get('children') instanceof Demo.Entities.RubyModules
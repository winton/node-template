export let init = Class =>
  class extends Class {
    init(args) {
      this.include(`${__dirname}/../../`)
      super.init(args)
    }
  }

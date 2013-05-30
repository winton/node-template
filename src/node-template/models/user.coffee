Bookshelf = require("bookshelf")

module.exports =
  User: User = Bookshelf.Model.extend(
    tableName: 'users'
  )
  Users: Users = Bookshelf.Model.extend(
    model: User
  )
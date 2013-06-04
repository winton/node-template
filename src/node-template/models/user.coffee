for key, value of require('./common')
  eval("var #{key} = value;")

module.exports =
  User: User = Bookshelf.Model.extend(
    tableName: 'users'
  )
  Users: Users = Bookshelf.Model.extend(
    model: User
  )
CppClassView = require './cpp-class-view'
{CompositeDisposable} = require 'atom'

module.exports = CppClass =
    activate: ->
        @view = new CppClassView()

    deactivate: ->
        @view?.destroy()

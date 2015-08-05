CppClassView = require './cpp-class-view'
{CompositeDisposable} = require 'atom'

module.exports = CppClass =
  cppClassView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @cppClassView = new CppClassView(state.cppClassViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @cppClassView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'cpp-class:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @cppClassView.destroy()

  serialize: ->
    cppClassViewState: @cppClassView.serialize()

  toggle: ->
    console.log 'CppClass was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

{$, TextEditorView, View} = require 'atom-space-pen-views'

module.exports =
class CppClassView extends View
    initialize: ->
        console.log('in the cpp-class-view intialize')

        @command_subscription = atom.commands.add 'atom-workspace', 'cpp-class:toggle': => @show()

    @content: ->
        @div class: 'cpp-class', =>
            @subview 'miniEditor', new TextEditorView(mini: true)
            @div class: 'error', outlet: 'error'
            @div class: 'message', outlet: 'message'

    toggle: ->
        console.log('toggling cpp-class')
        if @panel.isVisible()
            @hide()
        else
            @show()

    show: ->
        console.log('showing panel')
        @create_file_panel()
        @panel.show()

    hide: ->
        console.log('hiding panel')
        @panel.hide()

    create_file_panel: ->
        @panel ?= atom.workspace.addModalPanel(item: this, visible: false)
        console.log("creating panel, setting the message")
        @message.text("Enter C++ Class name")
        @miniEditor.focus()

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
        @panel?.destroy()
        @command_subscription.dispose()

    getElement: ->
        @element

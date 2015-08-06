path = require 'path'
fs = require 'fs-plus'
mkdirp = require 'mkdirp'
{$, TextEditorView, View} = require 'atom-space-pen-views'

module.exports =
class CppClassView extends View
    previously_focused: null
    initialize: ->
        @command_subscription = atom.commands.add 'atom-workspace', 'cpp-class:create': => @show()

        # @miniEditorClassName.on 'blur', => @close()
        atom.commands.add @element,
            'core:confirm': => @confirm()
            'core:cancel': => @close()

    @content: ->
        @div class: 'cpp-class', =>
            @div class: 'message', outlet: 'dirMessage'
            @subview 'miniEditorDirectoryName', new TextEditorView(mini: true)

            @div class: 'message', outlet: 'classMessage'
            @subview 'miniEditorClassName', new TextEditorView(mini: true)

            @div class: 'error', outlet: 'error'

    toggle: ->
        if @panel.isVisible()
            @hide()
        else
            @show()

    show: ->
        @create_file_panel()
        @previously_focused = $(document.activeElement)
        @panel.show()
        @miniEditorClassName.focus()

    hide: ->
        @panel.hide()
        @previously_focused?.focus()

    close: ->
        return unless @panel?.isVisible()
        console.log('closing')
        @hide()

    confirm: ->
        typed = @get_class_name()
        @create_class_files(typed)
        @hide()

    get_class_name: ->
        @miniEditorClassName.getText()

    get_directory_name: ->
        @miniEditorDirectoryName.getText()

    set_directory_text: (placeholder_name = "") ->
        editor = @miniEditorDirectoryName.getModel()
        project_dir = @get_project_directory()
        editor.setText(project_dir)

    get_project_directory: ->
        atom.project.getPaths()[0]

    create_class_files: (class_name) ->
        directory = @get_directory_name()
        mkdirp(directory)

        hpp_path = path.join(directory, @get_header_name(class_name))
        cpp_path = path.join(directory, @get_cpp_name(class_name))
        fs.writeFile(hpp_path, @get_hpp_content(class_name))
        fs.writeFile(cpp_path, @get_cpp_content(class_name))

    get_header_name: (class_name) ->
        "#{class_name}.hpp"

    get_cpp_name: (class_name) ->
        "#{class_name}.cpp"

    get_hpp_content: (class_name) ->
        "#ifndef #{class_name}_h\n" +
            "#define #{class_name}_h\n\n" +
            "class #{class_name} {\n" +
            "public:\n\n" +
            "private:\n\n" +
            "};\n\n" +
            "#endif"

    get_cpp_content: (class_name) ->
        "#include \"#{@get_header_name(class_name)}\""

    create_file_panel: ->
        @panel ?= atom.workspace.addModalPanel(item: this, visible: false)
        @dirMessage.text("Enter directory")
        @classMessage.text("Enter C++ Class name")
        @set_directory_text()

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
        @panel?.destroy()
        @command_subscription.dispose()

    getElement: ->
        @element

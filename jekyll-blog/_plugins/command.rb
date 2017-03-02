=begin
  Jekyll tag to include Markdown text from _includes directory preprocessing with Liquid.
  Usage:
    {% markdown <filename> %}
  Dependency:
    - kramdown
=end

module Jekyll
  class CommandTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      '<span class="command">'+ @text +'</div>'
    end
  end

  class CommandTagBlock < Liquid::Block
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      txt = super
      '<div class="command-blk" ">'+ txt +'</div>'
    end
  end


end

Liquid::Template.register_tag('command', Jekyll::CommandTag)
Liquid::Template.register_tag('cmdblock', Jekyll::CommandTagBlock)

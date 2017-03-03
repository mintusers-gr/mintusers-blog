# Turns:
#   {% kbd shift cmd V %}
# Into:
#   <kbd>⇧ shift</kbd><kbd>⌘ cmd</kbd><kbd>V</kbd>
module Jekyll
  class Kbd < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      @markup = markup

      # http://meta.apple.stackexchange.com/q/193/68
      @special = {
        'cmd'     => '&#8984; cmd',
        'ctrl'    => '&#8963; ctrl',
        'alt'     => '&#8997; alt',
        'shift'   => '&#8679; shift',
        'caps'    => '&#8682; caps lock',
        'eject'   => '&#9167; eject',
        'return'  => '&#9166; return',
        'delete'  => '&#9003; delete',
        'esc'     => '&#9099; esc',
        'right'   => '&rarr;',
        'left'    => '&larr;',
        'up'      => '&uarr;',
        'down'    => '&darr;',
        'tab'     => '&#8677; tab',
      }
      super
    end

    def render(context)
      keys = @markup.gsub(/\s+/m, ' ').strip.split(' ')
      keys.map! do |key|
        key = @special[key] if @special.has_key?(key)
        key = "<kbd>#{key}</kbd>"
      end
      keys.join('')
    end
  end
end

Liquid::Template.register_tag('kbd', Jekyll::Kbd)

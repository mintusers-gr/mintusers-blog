# encoding: utf-8
# The above is a 'magic encoding' that ensures support for special characters
# like umlauts in strings contained in this file.

module Jekyll
  module Tags
    class QuickManTag < Liquid::Tag

      def initialize(tag_name, section_page_provider, tokens)
        @section, @page, @provider = section_page_provider.split
        @provider = @provider || 'Ubuntu'
        super
      end

      def render(context)
        generate_anchor(context.registers[:site].config['man'])
      end

      def generate_anchor(man)
        description = determine_description(man)
        p "WARNING: None of the checked sources contained information about '#{@page}'" if description.empty?
        title = "#{@provider} Manpage for #{determine_type} '#{@page}#{description}'"

        href = determine_url

        "<a title=\"#{title}\" href=\"#{href}\">#{@page}(#{@section})</a>"
      end

			def determine_description_via_whatis
				man_path = "--manpath=`manpath --quiet --global`"
				section = @section ? "--section #{@section}" : ''
				# locale = "--locale=de"
				thats_it = `whatis #{man_path} #{section} --long --systems=#{@provider},man #{@page} 2> /dev/null`

        description = nil

				if thats_it != ''
					description = " - #{thats_it.split(/\) +-+ +/).last}"
					description.gsub!(/\n\Z/,'')
				end

				description
			end

      def determine_description_via_config(man)
        if man
			    man_page = man[@page]

					if man_page
						if man_page.is_a?(Hash) && man_page.has_key?(@section.to_i)
							# support for yaml paths like man.termios.4
							description = " - #{man_page[@section.to_i]}"
						else
							# support for yaml paths like man.ssh
							description = " - #{man_page}"
						end
					end
				end

        description || ''
			end

      def determine_description(man)
			  determine_description_via_whatis || determine_description_via_config(man) || ''
			end


      def determine_type
        if @provider.downcase.eql? 'ubuntu'
          get_type_linux
        else
          get_type_bsd
        end
      end

      def get_type_linux
        case @section.to_i
          when 1
            'User Commands'
          when 2
            'System Calls'
          when 3
            'C Library Functions'
          when 4
            'Devices and Special Files'
          when 5
            'File Formats and Conventions'
          when 6
            'Games et. al.'
          when 8
            'Miscellanea'
          when 9
            'System Administration tools and Daemons'
        else
            # 7 Verschiedenes (einschließlich Makropaketen und Konventionen), z. B. man(7), groff(7)
            ''
        end
      end

      def get_type_bsd
        case @section.to_i
          when 1
            'm Benutzerkommando'
          when 2
            'Systemaufruf oder Fehlernummer'
          when 3
            'm Bibliotheksaufruf'
          when 4
            ' Gerätetreiber'
          when 5
            'm Dateiformat/zur Konvention'
          when 6
            'm Spiel'
          when 8
            'm Systemverwaltungskommando'
          when 9
            'r Kernel-Entwicklerhilfe'
        else
          # 7 Verschiedene Informationen
          ''
        end
      end

      def determine_url
        case @provider.downcase
          when 'ubuntu'
            "http://manpages.ubuntu.com/manpages/#{@page}.#{@section}"
          else
            "http://www.freebsd.org/cgi/man.cgi?query=#{@page}&apropos=0&sektion=#{@section}&arch=default&format=latin1"
        end
      end

    end
  end
end

Liquid::Template.register_tag('man', Jekyll::Tags::QuickManTag)

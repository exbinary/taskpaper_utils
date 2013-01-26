module TaskpaperTools

  class LineItem
    attr_accessor :parent
    attr_accessor :children

    def initialize(text, preceding_item)
      @text = clean(text)
      @children = []
      determine_parent(preceding_item)
      @parent.children << self
    end

    #todo: these should not be public?
    def task?;     @text =~ /\A(\s*)?-/            end
    def project?;  @text.end_with?(':') && !task?  end
    def note?;     not (task? or project?)         end

    def determine_parent preceding_item
      if indents > preceding_item.indents
        @parent = preceding_item
      else
        @parent = preceding_item.find_common_ancestor self
      end
    end

    def text
      project? ? @text.chomp(':') : @text
    end

    def indents
      @text[/\A\t*/].size
    end

    def to_s
      "#{text} <- #{parent.text}"
    end

    protected

    def find_common_ancestor other
      if indents == other.indents
        #todo: refactor for clarity
        if self.project? && !other.project?
          return self 
        else
          return parent
        end
      end
      parent.find_common_ancestor other
    end

    private

    def clean(text = nil)
      text.rstrip.sub /\A */, ''
    end
  end

  #todo: a document is not a line item
  class Document < LineItem
    def initialize
      @children = []
    end
    def indents
      -1
    end
    def text
      #todo: append filepath
      "Document (*path*) "
    end
    def to_s
      text
    end

    def save path
      File.open(path, 'w') do |file|
        file << 'not implemented yet'
      end
    end
  end
end

module EasyType
  module FileIncluder

    # @private
    def self.included(parent)
      parent.extend(FileIncluder)
    end
    ##
    #
    # This is an implementation of a C like include. You can use this at places where Puppet doesn't support parent-classed
    # like when defining Custum Types. include_file uses the already established search path. If you need to include a file
    # from a subdircetory, use the subdirectory name
    # 
    # @example
    #
    #  include_file 'puppet/types/ora'
    #
    # @param name [String] this is the name of the file to be included
    # @raise [ArgumentError] when the specified file is not found
    # @return the evaluated content of the file
    #
    #
    def include_file(name)
      full_name = get_ruby_file(name)
      raise ArgumentError, "file #{name} not found" unless full_name
      eval(IO.read(full_name), nil, full_name)
    end

    private
      # @private
      def get_ruby_file(name)
        name = name + '.rb' unless name =~ /\.rb$/
        path = $LOAD_PATH.find { |dir| File.exist?(File.join(dir, name)) }
        path and File.join(path, name)
      end
    end
end

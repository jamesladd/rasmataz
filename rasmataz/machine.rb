
module RASMATAZ

  class Machine

    attr_accessor :registers, :stack, :memory, :labels

    public
 
      def all_register_names
        [general_register_names, index_and_pointer_register_names].flatten
      end

      def instructions
        <<-INSTRUCTIONS
        mov src dst
        push src
        pop dst
        dec src
        jnz lbl
        label name
        INSTRUCTIONS
      end

      def mov(src, dst)
        encode instruction.with(:mnemonic => :mov, :arg1 => src, :arg2 => dst)
      end

      def push(src)
        encode instruction.with(:mnemonic => :dec, :arg1 => src)
      end

      def pop(dst)
        encode instruction.with(:mnemonic => :pop, :arg1 => dst)
      end

      def dec(src)
        encode instruction.with(:mnemonic => :dec, :arg1 => src)
      end

      def jnz(label)
        encode instruction.with(:mnemonic => :jnz, :arg1 => label)
      end

      def label(name)
        encode_label instruction.with(:mnemonic => :label, :arg1 => name)
      end
 
      def go
        raise "No :start label found. Define one with 'label :start'." if labels[:start].nil?
      end

    private 

      def initialize
        @stack = []
        @memory = []
        @labels = {}
        @registers = hash_of_all_register_names
      end

      def encode(instruction)
        # empty - here to help readability of adding instructions for execution.
      end

      def encode_label(instruction)
        @labels[instruction.mnemonic] = instruction.pointer
      end

      def instruction
        @memory << Instruction.new(@memory.size)
        @memory.last
      end

      def hash_of_all_register_names
        all_register_names.inject({}) do | result, element |
          result[element] = 0
          result
        end
      end

      def general_register_names
        [ :rax, :rbx, :rcx, :rdx ]
      end

      def index_and_pointer_register_names
        [ :rsi, :rdi, :rbp, :rip, :rsp ]
      end
  end

  class Instruction

    attr_accessor :mnemonic, :pointer, :arg1, :arg2

    def initialize(pointer)
      @pointer = pointer
    end

    def with(attributes)
      attributes.keys.each { |key| send("#{key}=", attributes[key]) }
      self
    end

  end

end


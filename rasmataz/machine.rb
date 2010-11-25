
module RASMATAZ

  class Machine

    attr_accessor :registers, :stack, :memory

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
        puts "mov #{src}, #{dst.inspect}"
      end

      def push(src)
        puts "push #{src}"
      end

      def pop(dst)
        puts "pop #{dst}"
      end

      def dec(src)
        puts "dec #{src}"
      end

      def jnz(lbl)
        puts "jnz #{lbl}"
      end

      def label(name)
        puts "label #{name}"
      end

    private 

      def initialize
        @stack = []
        @memory = []
        @registers = hash_of_all_register_names
      end

      def hash_of_all_register_names
        all_register_names.inject({}) do | result, element |
          result[element] = 0
          result
        end
      end

      def general_register_names
        [ :eax, :ebx, :ecx, :edx ]
      end

      def index_and_pointer_register_names
        [ :esi, :edi, :ebp, :eip, :esp ]
      end
  end
end


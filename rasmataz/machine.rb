
module RASMATAZ

  class Machine

    attr_accessor :registers, :stack, :memory, :labels

    public
 
      def all_register_names
        [general_register_names, index_and_pointer_register_names].flatten
      end

      def instructions
        <<-INSTRUCTIONS
        halt
        nop
        mov src dst
        push src
        pop dst
        dec src
        jnz lbl
        label name
        INSTRUCTIONS
      end

      def halt()
        encode instruction.with(:mnemonic => :halt)
      end

      def nop()
        encode instruction.with(:mnemonic => :nop)
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
        raise "No #{start_label} label found. Define one with 'label #{start_label}'." if labels[start_label].nil?
		initialize_execution_registers
        while not memory[instruction_pointer].nil?
          execute memory[instruction_pointer]
          increment_instruction_pointer
        end
      end

    private 

      def initialize
        @stack = []
        @memory = []
        @labels = {}
        @registers = hash_of_all_register_names
      end

      def initialize_execution_registers
        registers[stack_pointer_register] = stack.size
        registers[instruction_pointer_register] = labels[start_label]
      end

      def start_label
        :start
      end

      def stack_pointer_register
        :rsp
      end

      def instruction_pointer_register
        :rip
      end

      def instruction_pointer
        registers[instruction_pointer_register]
      end

      def increment_instruction_pointer
        registers[instruction_pointer_register] += 1
      end

      def execute(instruction)
        puts instruction.inspect
      end
 
      def encode(instruction)
        # empty - here to help readability of adding instructions for execution.
      end

      def encode_label(instruction)
        @labels[instruction.arg1] = instruction.pointer
      end

      def instruction
        @memory << Instruction.new(self, @memory.size)
        @memory.last
      end

      def hash_of_all_register_names
        all_register_names.inject({}) do | result, element |
          result[element] = 0
          result
        end
      end

      def general_register_names
        [:rax, :rbx, :rcx, :rdx]
      end

      def index_and_pointer_register_names
        [:rsi, :rdi, :rbp, instruction_pointer_register, stack_pointer_register]
      end
  end

  class Instruction

    attr_accessor :mnemonic, :pointer, :arg1, :arg2

    def initialize(machine, pointer)
      @pointer = pointer
    end

    def with(attributes)
      attributes.keys.each { |key| send("#{key}=", attributes[key]) }
      self
    end

  end

end


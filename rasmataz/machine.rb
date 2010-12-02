
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
		inc src
        jnz lbl
        label name
        INSTRUCTIONS
      end

      # instruction pairs - one to encode into memory and one to execute against machine.

      def encode_halt()
        encode instruction.with(:mnemonic => :halt)
      end

      def execute_halt(instruction)
        @halted = true
      end

      def encode_nop()
        encode instruction.with(:mnemonic => :nop)
      end

      def execute_nop(instruction)
        # do no operation.
      end

      def encode_mov(src, dst)
        encode instruction.with(:mnemonic => :mov, :arg1 => src, :arg2 => dst)
      end

      def encode_push(src)
        encode instruction.with(:mnemonic => :dec, :arg1 => src)
      end

      def encode_pop(dst)
        encode instruction.with(:mnemonic => :pop, :arg1 => dst)
      end

      def encode_dec(src)
        encode instruction.with(:mnemonic => :dec, :arg1 => src)
      end

      def encode_jnz(label)
        encode instruction.with(:mnemonic => :jnz, :arg1 => label)
      end

      def encode_label(name)
        encode_label_label instruction.with(:mnemonic => :label, :arg1 => name)
      end
      alias execute_label execute_nop

      def go
        raise "No #{start_label} label found. Define one with 'label #{start_label}'." if labels[start_label].nil?
		initialize_execution_registers
        execute_instructions
      end

      def step
        return no_step if halted?
        execute memory[instruction_pointer]
        increment_instruction_pointer
      end

    private 

      def initialize
        @stack = []
        @memory = []
        @labels = {}
        @registers = hash_of_all_register_names
        @halted = false
      end

      def execute_instructions
        step while not memory[instruction_pointer].nil? and not halted?
      end

      def no_step
        '** HALTED **'
      end

      def halted?
        @halted
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
        send("execute_#{instruction.mnemonic}", instruction)
      end
 
      def encode(instruction)
        # empty - here to help readability of adding instructions for execution.
      end

      def encode_label_label(instruction)
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

    def args_size
      return 0 if arg1.nil? and arg2.nil?
      return 1 if not arg1.nil? and arg2.nil?
      return 2 if not arg1.nil? and not arg2.nil?
    end

  end

end


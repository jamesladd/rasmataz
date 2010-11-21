require 'rasmataz/machine.rb'

public 

  def mov(src, dst)
    puts "mov #{src}, #{dst}"
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

  def make_method(source)
    eval source
  end

  def general_registers
    [ :eax, :ebx, :ecx, :edx ]
  end

  def index_and_pointer_registers
    [ :esi, :edi, :ebp, :eip, :esp ]
  end

  def make_register_identifiers
    # define methods for each register 'name' to convert them into symbols.
    [general_registers, index_and_pointer_registers].flatten.each do | symbol |
      make_method "def #{symbol}() :#{symbol} end"
    end
  end

  def make_machine
    @machine = RASMATAZ::Machine.new
  end

  def rasmataz
    make_register_identifiers
    make_machine
  end


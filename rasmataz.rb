
public 

  def general_registers
    [ :eax, :ebx, :ecx, :edx ]
  end

  def index_and_pointer_registers
    [ :esi, :edi, :ebp, :eip, :esp ]
  end

  # define methods for each register 'name' to convert them into symbols.
  [general_registers, index_and_pointer_registers].flatten.each do | symbol |
    eval "def #{symbol.to_s}() :#{symbol} end"
  end

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


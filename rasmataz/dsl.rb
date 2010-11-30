require 'rasmataz/machine.rb'

private 

  def add_method(source)
    eval "def #{source} end"
  end

  def all_register_names
    @machine.all_register_names
  end
	   
  def add_register_identifier_methods
    # define methods for each register 'name' to convert them into symbols.
    all_register_names.each do | symbol |
      add_method "#{symbol}() :#{symbol}"
    end
  end

  def add_instruction_method(instruction)
    add_method "#{instruction[0]}() @machine.#{instruction[0]}()" if instruction.size == 1
    add_method "#{instruction[0]}(a1) @machine.#{instruction[0]}(a1)" if instruction.size == 2
    add_method "#{instruction[0]}(a1,a2) @machine.#{instruction[0]}(a1,a2)" if instruction.size == 3
  end

  def add_machine_delegate_methods
    ['registers', 'stack', 'memory', 'instructions', 'labels', 'go'].each do | name |
      add_method "#{name}() @machine.#{name}"
    end
  end

  def add_instruction_methods
    instructions.each_line { | line | add_instruction_method(line.split(' ')) }
  end

  def make_machine
    @machine = RASMATAZ::Machine.new
  end

  def rasmataz
    make_machine
    add_machine_delegate_methods
    add_register_identifier_methods
    add_instruction_methods
  end


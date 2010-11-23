
module RASMATAZ
  class Machine

    public
 
      def all_register_names
        [general_register_names, index_and_pointer_register_names].flatten
      end

    private 

      def general_register_names
        [ :eax, :ebx, :ecx, :edx ]
      end

      def index_and_pointer_register_names
        [ :esi, :edi, :ebp, :eip, :esp ]
      end
  end
end


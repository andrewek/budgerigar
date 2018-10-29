class AllocationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :amount, :category
end

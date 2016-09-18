def add x1:, x2:
  begin
    x1 +  x2
  rescue Exception => e
    raise ::ErrorStatus.new(code: 400, message: 'requires x1 and x2 args')
  end
end
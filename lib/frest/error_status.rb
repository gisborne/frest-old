class ErrorStatus < Exception
  def initialize code: 500, message: '', **other
    @code = code
    @message = message
    @other = other
  end
end
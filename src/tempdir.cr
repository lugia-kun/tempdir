require "file_utils"

# Creates a temporary directory.
class Tempdir < Dir
  VERSION = "0.1.0"

  # Creates a new temporary directory.
  #
  # The given arguments will be passed to `File.tempname` as-is.
  #
  # Directory will be created with 0o700 permission.
  #
  # This method raises ArgumentError if parent directory of created
  # directory is writable by others and not skicky bit is set.
  def initialize(**args)
    path = File.tempname(**args)
    Dir.mkdir(path, 0o700)
    info = File.info(File.dirname(path))
    if info.permissions.other_write? && !info.flags.sticky?
      FileUtils.rm_rf(path)
      raise ArgumentError.new("parent directory is other writable but not sticky")
    end
    super(path)
  end

  # Close temporary directory and remove its entries.
  def close
    super
    FileUtils.rm_rf(self.path)
  end
end

class Dir
  # Creates a new temporary directory
  #
  # The given arguments will be passed to `File.tempname` as-is.
  #
  # Alias for `Tempdir.new`.
  def self.mktmpdir(**args)
    Tempdir.new(**args)
  end

  # Creates a new temporary directory and yield block with its path
  def self.mktmpdir(**args, &block)
    dir = mktmpdir(**args)
    begin
      yield dir.path
    ensure
      dir.close
    end
  end
end

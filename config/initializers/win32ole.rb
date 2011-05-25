require 'win32ole.so'

# Fail if not required by main thread.
# Call OleInitialize and OleUninitialize for main thread to satisfy the following:
#
# The first thread in the application that calls CoInitialize with 0 (or CoInitializeEx with COINIT_APARTMENTTHREADED)
# must be the last thread to call CoUninitialize. Otherwise, subsequent calls to CoInitialize on the STA will fail and the
# application will not work.
#
# See http://msdn.microsoft.com/en-us/library/ms678543(v=VS.85).aspx
if Thread.main != Thread.current
  raise "Require win32ole.rb from the main application thread to satisfy CoInitialize requirements."
else
  WIN32OLE.ole_initialize
  at_exit { WIN32OLE.ole_uninitialize }
end


# re-define Thread#initialize
# bug #2618(ruby-core:27634)

class Thread
  alias :org_initialize :initialize
  def initialize(*arg, &block)
    if block
      org_initialize(*arg) {
        WIN32OLE.ole_initialize
        begin
          block.call(*arg)
        ensure
          WIN32OLE.ole_uninitialize
        end
      }
    else
      org_initialize(*arg)
    end
  end
end
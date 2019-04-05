# Copyright 2019 cbrnrd
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
module Star
  VERSION = "0.2.2"

  # These constants are things in the file specification
  class Spec
    BEGIN_FILE_LIST = "\xCA\xFE\xCA\xFE\xBA\xBE\xBA\xBE"
    END_FILE_LIST = "\xBA\xBE\xBA\xBE\xCA\xFE\xCA\xFE"
    BEGIN_FILE = "\x53\x20\x54\x20\x41\x20\x52\x20\x42\x20\x45\x20\x47\x20\x49\x20\x4e\x20\x5c\x20\x5c\x20\x26\x24"
    END_FILE = "\x53\x20\x54\x20\x41\x20\x52\x20\x45\x20\x4e\x20\x44\x20\x4f\x20\x46\x20\x5c\x20\x5c\x20\x26\x24"
  end
end
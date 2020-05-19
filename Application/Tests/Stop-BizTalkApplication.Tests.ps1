#region Copyright & License

# Copyright © 2012 - 2020 François Chabot
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#endregion

Import-Module -Name $PSScriptRoot\..\Application -Force

Describe 'Stop-BizTalkApplication' {
    InModuleScope Application {

        Context 'Stopping BizTalk Server applications' {
            It 'Stopping an application disables and unenlists all BizTalk services.' {
                Get-BizTalkApplication -Name 'BizTalk EDI Application' | Select-Object -ExpandProperty Status | Should -Be 'Started'

                Stop-BizTalkApplication -Name 'BizTalk EDI Application'

                Get-BizTalkApplication -Name 'BizTalk EDI Application' | ForEach-Object -Process {
                    $_.Status | Should -Be 'Stopped'
                    $_.ReceivePorts.ReceiveLocations | ForEach-Object -Process { $_.Enable | Should -BeFalse }
                    $_.Orchestrations | ForEach-Object -Process { $_.Status | Should -Be 'Unenlisted' }
                }
            }
        }

    }
}

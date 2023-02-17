[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath '..\..\Unit' `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Microsoft365.psm1' `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Generic.psm1' `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource 'IntuneDeviceCompliancePolicyAndroidWorkProfile' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin', $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicyAssignment -MockWith {

                return @()
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the Android Work Profile Device Compliance Policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                        = 'Test Android Work Profile Device Compliance Policy'
                    Description                                        = 'Test Android Work Profile Device Compliance Policy Description'
                    PasswordRequired                                   = $True
                    PasswordMinimumLength                              = 6
                    PasswordRequiredType                               = 'DeviceDefault'
                    PasswordMinutesOfInactivityBeforeLock              = 5
                    PasswordExpirationDays                             = 365
                    PasswordPreviousPasswordBlockCount                 = 10
                    PasswordSignInFailureCountBeforeFactoryReset       = 11
                    SecurityPreventInstallAppsFromUnknownSources       = $True
                    SecurityDisableUsbDebugging                        = $True
                    SecurityRequireVerifyApps                          = $True
                    DeviceThreatProtectionEnabled                      = $True
                    DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                    AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                    SecurityBlockJailbrokenDevices                     = $True
                    OsMinimumVersion                                   = 7
                    OsMaximumVersion                                   = 11
                    StorageRequireEncryption                           = $True
                    SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                    SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                    SecurityRequireGooglePlayServices                  = $True
                    SecurityRequireUpToDateSecurityProviders           = $True
                    SecurityRequireCompanyPortalAppIntegrity           = $True
                    Ensure                                             = 'Present'
                    Credential                                         = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the Android Device Compliance Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgBetaDeviceManagementDeviceCompliancePolicy' -Exactly 1
            }
        }

        Context -Name 'When the Android Device Compliance Policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                        = 'Test Android Work Profile Device Compliance Policy'
                    Description                                        = 'Different Value'
                    PasswordRequired                                   = $True
                    PasswordMinimumLength                              = 6
                    PasswordRequiredType                               = 'DeviceDefault'
                    PasswordMinutesOfInactivityBeforeLock              = 5
                    PasswordExpirationDays                             = 365
                    PasswordPreviousPasswordBlockCount                 = 10
                    PasswordSignInFailureCountBeforeFactoryReset       = 11
                    SecurityPreventInstallAppsFromUnknownSources       = $True
                    SecurityDisableUsbDebugging                        = $True
                    SecurityRequireVerifyApps                          = $True
                    DeviceThreatProtectionEnabled                      = $True
                    DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                    AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                    SecurityBlockJailbrokenDevices                     = $True
                    OsMinimumVersion                                   = 7
                    OsMaximumVersion                                   = 11
                    StorageRequireEncryption                           = $True
                    SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                    SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                    SecurityRequireGooglePlayServices                  = $True
                    SecurityRequireUpToDateSecurityProviders           = $True
                    SecurityRequireCompanyPortalAppIntegrity           = $True
                    Ensure                                             = 'Present'
                    Credential                                         = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
                    return @{
                        DisplayName          = 'Test Android Work Profile Device Compliance Policy'
                        Description          = 'Test Android Work Profile Device Compliance Policy Description'
                        Id                   = '9c4e2ed7-706e-4874-a826-0c2778352d47'
                        AdditionalProperties = @{
                            '@odata.type'                                      = '#microsoft.graph.androidWorkProfileCompliancePolicy'
                            PasswordRequired                                   = $True
                            PasswordMinimumLength                              = 6
                            PasswordRequiredType                               = 'DeviceDefault'
                            RequiredPasswordComplexity                         = 'None'
                            PasswordMinutesOfInactivityBeforeLock              = 5
                            PasswordExpirationDays                             = 365
                            PasswordPreviousPasswordBlockCount                 = 10
                            PasswordSignInFailureCountBeforeFactoryReset       = 11
                            SecurityPreventInstallAppsFromUnknownSources       = $True
                            SecurityDisableUsbDebugging                        = $True
                            SecurityRequireVerifyApps                          = $True
                            DeviceThreatProtectionEnabled                      = $True
                            DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                            AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                            SecurityBlockJailbrokenDevices                     = $True
                            OsMinimumVersion                                   = 7
                            OsMaximumVersion                                   = 11
                            StorageRequireEncryption                           = $True
                            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                            SecurityRequireGooglePlayServices                  = $True
                            SecurityRequireUpToDateSecurityProviders           = $True
                            SecurityRequireCompanyPortalAppIntegrity           = $True
                            RoleScopeTagIds                                    = '0'
                        }
                    }
                }
            }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the iOS Device Compliance Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceCompliancePolicy -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                        = 'Test Android Work Profile Device Compliance Policy'
                    Description                                        = 'Test Android Work Profile Device Compliance Policy Description'
                    PasswordRequired                                   = $True
                    PasswordMinimumLength                              = 6
                    PasswordRequiredType                               = 'DeviceDefault'
                    PasswordMinutesOfInactivityBeforeLock              = 5
                    PasswordExpirationDays                             = 365
                    PasswordPreviousPasswordBlockCount                 = 10
                    PasswordSignInFailureCountBeforeFactoryReset       = 11
                    SecurityPreventInstallAppsFromUnknownSources       = $True
                    SecurityDisableUsbDebugging                        = $True
                    SecurityRequireVerifyApps                          = $True
                    DeviceThreatProtectionEnabled                      = $True
                    DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                    AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                    SecurityBlockJailbrokenDevices                     = $True
                    OsMinimumVersion                                   = 7
                    OsMaximumVersion                                   = 11
                    StorageRequireEncryption                           = $True
                    SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                    SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                    SecurityRequireGooglePlayServices                  = $True
                    SecurityRequireUpToDateSecurityProviders           = $True
                    SecurityRequireCompanyPortalAppIntegrity           = $True
                    Ensure                                             = 'Present'
                    Credential                                         = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
                    return @{
                        DisplayName          = 'Test Android Work Profile Device Compliance Policy'
                        Description          = 'Test Android Work Profile Device Compliance Policy Description'
                        Id                   = '9c4e2ed7-706e-4874-a826-0c2778352d46'
                        AdditionalProperties = @{
                            '@odata.type'                                      = '#microsoft.graph.androidWorkProfileCompliancePolicy'
                            PasswordRequired                                   = $True
                            PasswordMinimumLength                              = 6
                            PasswordRequiredType                               = 'DeviceDefault'
                            RequiredPasswordComplexity                         = 'None'
                            PasswordMinutesOfInactivityBeforeLock              = 5
                            PasswordExpirationDays                             = 365
                            PasswordPreviousPasswordBlockCount                 = 10
                            PasswordSignInFailureCountBeforeFactoryReset       = 11
                            SecurityPreventInstallAppsFromUnknownSources       = $True
                            SecurityDisableUsbDebugging                        = $True
                            SecurityRequireVerifyApps                          = $True
                            DeviceThreatProtectionEnabled                      = $True
                            DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                            AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                            SecurityBlockJailbrokenDevices                     = $True
                            OsMinimumVersion                                   = 7
                            OsMaximumVersion                                   = 11
                            StorageRequireEncryption                           = $True
                            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                            SecurityRequireGooglePlayServices                  = $True
                            SecurityRequireUpToDateSecurityProviders           = $True
                            SecurityRequireCompanyPortalAppIntegrity           = $True
                            RoleScopeTagIds                                    = '0'
                        }
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the policy exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                        = 'Test Android Work Profile Device Compliance Policy'
                    Description                                        = 'Test Android Work Profile Device Compliance Policy Description'
                    PasswordRequired                                   = $True
                    PasswordMinimumLength                              = 6
                    PasswordRequiredType                               = 'DeviceDefault'
                    PasswordMinutesOfInactivityBeforeLock              = 5
                    PasswordExpirationDays                             = 365
                    PasswordPreviousPasswordBlockCount                 = 10
                    PasswordSignInFailureCountBeforeFactoryReset       = 11
                    SecurityPreventInstallAppsFromUnknownSources       = $True
                    SecurityDisableUsbDebugging                        = $True
                    SecurityRequireVerifyApps                          = $True
                    DeviceThreatProtectionEnabled                      = $True
                    DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                    AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                    SecurityBlockJailbrokenDevices                     = $True
                    OsMinimumVersion                                   = 7
                    OsMaximumVersion                                   = 11
                    StorageRequireEncryption                           = $True
                    SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                    SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                    SecurityRequireGooglePlayServices                  = $True
                    SecurityRequireUpToDateSecurityProviders           = $True
                    SecurityRequireCompanyPortalAppIntegrity           = $True
                    Ensure                                             = 'Absent'
                    Credential                                         = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
                    return @{
                        DisplayName          = 'Test Android Work Profile Device Compliance Policy'
                        Description          = 'Test Android Work Profile Device Compliance Policy Description'
                        Id                   = '9c4e2ed7-706e-4874-a826-0c2778352d46'
                        AdditionalProperties = @{
                            '@odata.type'                                      = '#microsoft.graph.androidWorkProfileCompliancePolicy'
                            PasswordRequired                                   = $True
                            PasswordMinimumLength                              = 6
                            PasswordRequiredType                               = 'DeviceDefault'
                            RequiredPasswordComplexity                         = 'None'
                            PasswordMinutesOfInactivityBeforeLock              = 5
                            PasswordExpirationDays                             = 365
                            PasswordPreviousPasswordBlockCount                 = 10
                            PasswordSignInFailureCountBeforeFactoryReset       = 11
                            SecurityPreventInstallAppsFromUnknownSources       = $True
                            SecurityDisableUsbDebugging                        = $True
                            SecurityRequireVerifyApps                          = $True
                            DeviceThreatProtectionEnabled                      = $True
                            DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                            AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                            SecurityBlockJailbrokenDevices                     = $True
                            OsMinimumVersion                                   = 7
                            OsMaximumVersion                                   = 11
                            StorageRequireEncryption                           = $True
                            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                            SecurityRequireGooglePlayServices                  = $True
                            SecurityRequireUpToDateSecurityProviders           = $True
                            SecurityRequireCompanyPortalAppIntegrity           = $True
                            RoleScopeTagIds                                    = '0'
                        }
                    }
                }
            }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the iOS Device Compliance Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceCompliancePolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
                    return @{
                        DisplayName          = 'Test Android Device Compliance Policy'
                        Description          = 'Test Android Device Compliance Policy Description'
                        Id                   = '9c4e2ed7-706e-4874-a826-0c2778352d46'
                        AdditionalProperties = @{
                            '@odata.type'                                      = '#microsoft.graph.androidWorkProfileCompliancePolicy'
                            PasswordRequired                                   = $True
                            PasswordMinimumLength                              = 6
                            PasswordRequiredType                               = 'DeviceDefault'
                            RequiredPasswordComplexity                         = 'None'
                            PasswordMinutesOfInactivityBeforeLock              = 5
                            PasswordExpirationDays                             = 365
                            PasswordPreviousPasswordBlockCount                 = 10
                            PasswordSignInFailureCountBeforeFactoryReset       = 11
                            SecurityPreventInstallAppsFromUnknownSources       = $True
                            SecurityDisableUsbDebugging                        = $True
                            SecurityRequireVerifyApps                          = $True
                            DeviceThreatProtectionEnabled                      = $True
                            DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                            AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                            SecurityBlockJailbrokenDevices                     = $True
                            OsMinimumVersion                                   = 7
                            OsMaximumVersion                                   = 11
                            StorageRequireEncryption                           = $True
                            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                            SecurityRequireGooglePlayServices                  = $True
                            SecurityRequireUpToDateSecurityProviders           = $True
                            SecurityRequireCompanyPortalAppIntegrity           = $True
                        }
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope

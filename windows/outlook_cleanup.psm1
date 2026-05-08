# Make sure Outlook is installed and configured on this profile before running.
# Run PowerShell in the same bitness as Outlook (usually 64-bit on modern systems).
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process
#  ipmo .\outlook_cleanup.psm1
#  New-MailboxArchiveStructure
#  Move-OldInboxMail -DaysBack 1825
function New-MailboxArchiveStructure {
    <#
        .SYNOPSIS
        Creates an "Archive" folder at the mailbox root and
        YYYY-MM subfolders from the oldest mail in Inbox up to the current month.

        .PARAMETER ArchiveRootName
        Name of the root archive folder (default: "Archive").

        .OUTPUTS
        [datetime] The date of the oldest item in the Inbox, or $null if Inbox is empty.
    #>
    param(
        [string]$ArchiveRootName = "Archive"
    )

    $outlook   = New-Object -ComObject Outlook.Application
    $namespace = $outlook.GetNameSpace("MAPI")
    # 6 = olFolderInbox
    $inbox     = $namespace.GetDefaultFolder(6)
    $items     = $inbox.Items

    if ($items.Count -eq 0) {
        Write-Host "Inbox is empty. Nothing to do."
        return $null
    }

    # Sort ascending by ReceivedTime so the first item is the oldest.
    $items.Sort("[ReceivedTime]")

    $oldestItem = $items.GetFirst()
    $startDate  = $oldestItem.ReceivedTime

    # Mailbox root (same level where Inbox, Sent Items, etc. live)
    $mailboxRoot = $inbox.Parent

    # Ensure Archive root exists
    $archiveFolder = $mailboxRoot.Folders | Where-Object { $_.Name -eq $ArchiveRootName }
    if (-not $archiveFolder) {
        $archiveFolder = $mailboxRoot.Folders.Add($ArchiveRootName)
        Write-Host "Created archive root folder '$ArchiveRootName'."
    }

    $now   = Get-Date
    $year  = $startDate.Year
    $month = $startDate.Month

    # Loop from oldest mail's year-month to current year-month
    while ( ($year -lt $now.Year) -or ( ($year -eq $now.Year) -and ($month -le $now.Month) ) ) {
        $folderName = "{0:0000}-{1:00}" -f $year, $month

        # Create YYYY-MM under Archive if it doesn't already exist
        if (-not ($archiveFolder.Folders | Where-Object { $_.Name -eq $folderName })) {
            $archiveFolder.Folders.Add($folderName) | Out-Null
            Write-Host "Created folder:" $folderName
        }

        # Increment month
        $month++
        if ($month -gt 12) {
            $month = 1
            $year++
        }
    }

    return $startDate
}

function Move-OldInboxMail {
    <#
        .SYNOPSIS
        Moves Inbox emails older than a given number of days into
        Archive\YYYY-MM folders based on their ReceivedTime.

        .PARAMETER DaysBack
        Number of days back from today; messages older than this are moved.
        Default is 31.

        .PARAMETER ArchiveRootName
        Name of the root archive folder (default: "Archive").
    #>
    param(
        [int]$DaysBack = 31,
        [string]$ArchiveRootName = "Archive"
    )

    $cutoff = (Get-Date).AddDays(-$DaysBack)

    $outlook   = New-Object -ComObject Outlook.Application
    $namespace = $outlook.GetNameSpace("MAPI")
    $inbox     = $namespace.GetDefaultFolder(6) # olFolderInbox
    $items     = $inbox.Items

    if ($items.Count -eq 0) {
        Write-Host "Inbox is empty. Nothing to move."
        return
    }

    # Mailbox root is the parent of Inbox
    $mailboxRoot = $inbox.Parent

    # Ensure Archive root exists (create if missing)
    $archiveFolder = $mailboxRoot.Folders | Where-Object { $_.Name -eq $ArchiveRootName }
    if (-not $archiveFolder) {
        $archiveFolder = $mailboxRoot.Folders.Add($ArchiveRootName)
        Write-Host "Archive root folder '$ArchiveRootName' did not exist and was created."
    }

    # Sort so we can iterate safely backwards
    $items.Sort("[ReceivedTime]")
    $count = $items.Count

    Write-Host "Scanning $count item(s) in Inbox for messages older than $DaysBack day(s)..."

    # Iterate backwards so index remains valid while moving items
    for ($i = $count; $i -ge 1; $i--) {
        $item = $items.Item($i)

        if (-not $item) { continue }

        # Skip non-mail items (e.g., meeting requests, reports, etc.)
        # Using MessageClass is more robust than type checking the COM interface.
        if ($item.MessageClass -notlike "IPM.Note*") { continue }

        $received = $item.ReceivedTime
        if (-not $received) { continue }

        # Only move if older than cutoff
        if ($received -gt $cutoff) { continue }

        # Determine YYYY-MM target folder name based on ReceivedTime
        $folderName = "{0:0000}-{1:00}" -f $received.Year, $received.Month

        # Find or create the destination subfolder under Archive
        $targetFolder = $archiveFolder.Folders | Where-Object { $_.Name -eq $folderName }
        if (-not $targetFolder) {
            $targetFolder = $archiveFolder.Folders.Add($folderName)
            Write-Host "Created missing archive subfolder:" $folderName
        }

        # Move the item
        $null = $item.Move($targetFolder)
        Write-Host ("Moved message received {0} to {1}\{2}" -f $received, $ArchiveRootName, $folderName)
    }

    Write-Host "Done moving old messages."
}

<# 
Example usage:

# 1. Create the Archive structure from oldest Inbox mail to now:
#    (Run once, or whenever you want to ensure folders exist)
New-MailboxArchiveStructure -ArchiveRootName "Archive"

# 2. Move messages older than 31 days into Archive\YYYY-MM:
Move-OldInboxMail -DaysBack 31 -ArchiveRootName "Archive"

#>


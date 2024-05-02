# Step 1: Check if winget is installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget is not installed. Please install it manually from the Microsoft Store."
    exit 1
}

# Step 2: Install Neovim using winget
if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
    winget install Neovim.Neovim
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install Neovim."
        exit 1
    }
}

# Step 3: Install zig to resolve C compiler error
if (-not (Get-Command zig -ErrorAction SilentlyContinue)) {
    winget install -e --id zig.zig
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install zig."
        exit 1
    }
}

# Install rustup (if not already installed)
if (-not (Test-Path $env:USERPROFILE\.cargo)) {
    Invoke-WebRequest -Uri https://sh.rustup.rs -OutFile $env:TEMP\rustup-init.exe
    Start-Process -FilePath $env:TEMP\rustup-init.exe -ArgumentList '/silent', '/components=rustfmt', '/default-host=x86_64-pc-windows-msvc', '/default-toolchain=stable' -Wait
    Remove-Item $env:TEMP\rustup-init.exe
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install rustup."
        exit 1
    }
}

# Install ripgrep (if not already installed)
if (-not (Get-Command rg -ErrorAction SilentlyContinue)) {
    cargo install ripgrep
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install ripgrep."
        exit 1
    }
}

# Check if Git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed. Please install it before proceeding."
    exit 1
}

# Step 4: Clone repo
if (-not (Test-Path "$env:USERPROFILE\AppData\Local\nvim")) {
    git clone git@github.com:mandeepsmagh/neovim-config.git --depth 1 "$env:USERPROFILE\AppData\Local\nvim"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to clone the repository."
        exit 1
    }
}

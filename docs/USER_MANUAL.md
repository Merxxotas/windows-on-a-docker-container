# User Manual: Remmina, FreeRDP, Shared Storage & Scripts

Complete reference manual for using the Windows VM, configuring bidirectional clipboard, local audio, shared folders, and automation scripts.

---

## 1. RDP Connection via Remmina (GUI)

### Configuration Steps:
1. Open **Remmina** from your application menu.
2. Click the **`+`** icon (Create new connection profile).
3. Fill in the **Basic** fields:
   - **Name**: `Windows VM`
   - **Protocol**: `RDP - Remote Desktop Protocol`
   - **Server**: `localhost:3389`
   - **Username**: `merxx`
   - **Password**: `030414`

4. **Enable Bidirectional Clipboard (`Ctrl+C` / `Ctrl+V`)**:
   - Go to the **Advanced** tab.
   - Locate the **Disable clipboard** checkbox.
   - **Ensure this option is UNCHECKED** (unchecking it keeps the clipboard enabled).

5. **Enable Audio Output**:
   - In the **Advanced** tab, locate **Audio output**.
   - Change it to **`Local`** (to route Windows audio to your CachyOS speakers/headphones).

6. Click **Save and Connect**.

---

## 2. RDP Connection via FreeRDP (`xfreerdp3`) (Command Line)

For an instant one-click connection from the terminal:

```bash
xfreerdp3 /v:localhost:3389 /u:merxx /p:030414 +clipboard /dynamic-resolution /sound:sys:pulse
```

### Parameter Breakdown:
- `/v:localhost:3389`: Server address and RDP port.
- `/u:merxx /p:030414`: Auto-login credentials.
- `+clipboard`: Enables bidirectional copy/paste between CachyOS and Windows.
- `/dynamic-resolution`: Automatically resizes Windows display resolution when resizing the client window.
- `/sound:sys:pulse`: Routes audio via PipeWire / PulseAudio.

---

## 3. Host ↔ Guest Shared Storage

Directories mounted in the `/shared` volume are exposed inside Windows via the container's built-in SMB server.

Inside Windows:
1. Open **File Explorer**.
2. Type in the address bar or navigate to **Network**:
   - `\\host.lan\home` (Access to `/home/merxx`)
   - `\\host.lan\vicioo` (Access to `/mnt/vicioo`)

---

## 4. Bash Automation Scripts (`scripts/`)

Executable management scripts are available in the `scripts/` directory:

- **Start VM and launch RDP (1 step)**:
  ```bash
  ./scripts/win-start.sh
  ```
- **Safely stop VM (free up RAM & CPU)**:
  ```bash
  ./scripts/win-stop.sh
  ```
- **Check VM status & resource usage (RAM/CPU/Ports)**:
  ```bash
  ./scripts/win-status.sh
  ```
- **Create instant disk snapshot (`data.img`)**:
  ```bash
  ./scripts/backup-vm.sh
  ```
  *(Uses BTRFS Copy-On-Write reflink without using extra disk space until modified).*

---

## 5. VM Lifecycle & Port 3389 Management

- **Is port 3389 always open?**
  No. Port 3389 is only open while the `windows` Docker container is running.

- **Stop VM (closes port 3389)**:
  ```bash
  ./scripts/win-stop.sh
  ```

- **Restart VM**:
  ```bash
  ./scripts/win-start.sh
  ```

- **Disable auto-start on system boot**:
  In `compose.yml`, change `restart: always` to `restart: "no"`.

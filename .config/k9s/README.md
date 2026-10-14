# k9s

k9s config set up so you rarely need `kubectl`. Tested against k9s v0.51.

## Plugins (`plugins/`)

| Key | View | What it does | File |
| --- | --- | --- | --- |
| `Shift-X` | Pods | Unhealthy pods across all namespaces | `failed-pods.yaml` |
| `Shift-E` | Any | Events for the selected resource | `inspect.yaml` |
| `Ctrl-Y` | Any | Copy that clean YAML to the clipboard (`wl-copy`) | `inspect.yaml` |
| `Shift-B` | Ingresses, HTTPRoutes | Open the host in the browser | `inspect.yaml` |
| `Shift-R` | Argo apps | Hard refresh (no `argocd login` needed) | `argocd.yaml` |
| `Shift-Z` | Argo apps | Sync, asks to confirm | `argocd.yaml` |
| `Shift-T` | Nodes | Talos dashboard | `talos.yaml` |
| `Shift-L` | Nodes | Talos service logs (pick the service) | `talos.yaml` |
| `Shift-K` | Nodes | Talos kernel log (`dmesg`) | `talos.yaml` |
| `Shift-V` | Any | API resources list | `api-resources.yaml` |

The Talos plugins expect the talosctl context to have the same name as the kube context.

## Views (`views.yaml`)

Custom columns for pods, deployments (image and version), nodes (OS image, IP, zone, instance type), PVCs, Argo applications (sync, health, source, short revision) and cert-manager certificates (sorted by expiry).

## Aliases (`aliases.yaml`)

- `:apps` opens Argo applications in the `argocd` namespace.
- `:crash` lists pods in bad states (CrashLoop, Pending, OOM, Evicted and so on) across all namespaces.

## Gotchas

- **Plugins can't reuse built-in keys.** k9s skips a plugin whose key is already taken, for example `Shift-G` (go to bottom) or `Shift-F` (port-forward). Check `?` in the view before picking a key.
- **jq columns need two or more `|` pipes**, otherwise k9s parses the column as JSONPath. See the Argo columns in `views.yaml`.
- **Column names that match a CRD's own column are merged with it**, and can end up hidden in wide mode. That's why the Argo revision column is called `REV`.
- **`|T` on a column shows time since**, so future dates (like certificate expiry) show as `<invalid>`.
- **Filters match every visible column**, so a word like `unknown` in `:crash` matched every pod.
- **Problems only show up in the log**, at `~/.local/state/k9s/k9s.log`.

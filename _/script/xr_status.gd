class_name XrStatus extends Node

## ---- Signals designers can hook into ----

signal on_xr_support_detected(supported: bool)
signal on_xr_backend_detected(available: bool)
signal on_xr_session_changed(active: bool)
signal on_disable_targets_if_in_xr()

## Combined signal if they want everything at once
signal xr_status_updated(status: Dictionary)

@export_group("Debug")
@export var _last_support := false
@export var _last_backend := false
@export var _last_session := false


func _ready():
	# Listen for runtime XR changes (device plugged in, runtime started, etc.)
	XRServer.interface_added.connect(_on_interfaces_changed)
	XRServer.interface_removed.connect(_on_interfaces_changed)

	# Initial evaluation
	_evaluate()


# ------------------------------------------------------------------
# Public query methods (usable from gameplay code if needed)
# ------------------------------------------------------------------

func is_xr_supported() -> bool:
	# Engine/export has XR capability compiled in
	return XRServer.get_interface_count() > 0


func is_xr_backend_available(name: String = "OpenXR") -> bool:
	# Specific backend plugin exists
	return XRServer.find_interface(name) != null


func is_xr_session_active() -> bool:
	# Headset session is actually running
	var iface := XRServer.get_primary_interface()
	return iface != null and iface.is_initialized()


func get_full_status() -> Dictionary:
	return {
		"supported": is_xr_supported(),
		"backend_available": is_xr_backend_available(),
		"session_active": is_xr_session_active()
	}


# ------------------------------------------------------------------
# Internal logic
# ------------------------------------------------------------------

func _on_interfaces_changed(_name: String):
	_evaluate()


func _evaluate():
	var support := is_xr_supported()
	var backend := is_xr_backend_available()
	var session := is_xr_session_active()

	if support != _last_support:
		_last_support = support
		on_xr_support_detected.emit(support)

	if backend != _last_backend:
		_last_backend = backend
		on_xr_backend_detected.emit(backend)

	if session != _last_session:
		_last_session = session
		on_xr_session_changed.emit(session)
		on_disable_targets_if_in_xr.emit()

	xr_status_updated.emit({
		"supported": support,
		"backend_available": backend,
		"session_active": session
	})

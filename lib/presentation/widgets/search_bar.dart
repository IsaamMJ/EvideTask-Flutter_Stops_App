import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';

class StopSearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final VoidCallback onClear;
  final String initialValue;
  final List<String>? suggestions;

  const StopSearchBar({
    Key? key,
    required this.onChanged,
    required this.onClear,
    this.initialValue = '',
    this.suggestions,
  }) : super(key: key);

  @override
  State<StopSearchBar> createState() => _StopSearchBarState();
}

class _StopSearchBarState extends State<StopSearchBar>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  Timer? _debounceTimer;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged(String value) {
    setState(() {
      _isSearching = value.isNotEmpty;
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onChanged(value);
    });
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _isSearching = false;
    });
    widget.onClear();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search stops, routes...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : AppColors.neutralGray,
                        fontWeight: FontWeight.normal,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _isSearching
                              ? SizedBox(
                            key: const ValueKey('loading'),
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryBlue,
                            ),
                          )
                              : Icon(
                            key: const ValueKey('search'),
                            Icons.search_rounded,
                            color: isDark ? Colors.grey[400] : AppColors.neutralGray,
                            size: 24,
                          ),
                        ),
                      ),
                      suffixIcon: _controller.text.isNotEmpty
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.suggestions != null && _controller.text.isNotEmpty)
                            IconButton(
                              icon: Icon(
                                Icons.history,
                                color: isDark ? Colors.grey[400] : AppColors.neutralGray,
                                size: 20,
                              ),
                              onPressed: () => _showSuggestions(),
                              tooltip: 'Recent searches',
                            ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppColors.neutralGray.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: isDark ? Colors.grey[400] : AppColors.neutralGray,
                                size: 20,
                              ),
                              onPressed: _clearSearch,
                              tooltip: 'Clear search',
                            ),
                          ),
                        ],
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.primaryBlue,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    onChanged: _onTextChanged,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        widget.onChanged(value);
                        _focusNode.unfocus();
                      }
                    },
                    textInputAction: TextInputAction.search,
                  ),
                ),

                // Quick filters (optional)
                if (_focusNode.hasFocus && widget.suggestions != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _focusNode.hasFocus ? 50 : 0,
                    child: _focusNode.hasFocus ? _buildQuickFilters(isDark) : null,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickFilters(bool isDark) {
    final filters = ['Metro', 'Bus', 'Ferry', 'All'];

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: false,
                onSelected: (selected) {
                  _controller.text = filter == 'All' ? '' : filter.toLowerCase();
                  widget.onChanged(_controller.text);
                  _focusNode.unfocus();
                },
                backgroundColor: isDark ? Colors.grey[700] : Colors.grey[100],
                selectedColor: AppColors.primaryBlue.withOpacity(0.2),
                checkmarkColor: AppColors.primaryBlue,
                labelStyle: TextStyle(
                  color: isDark ? Colors.grey[300] : Colors.black87,
                ),
                side: BorderSide(
                  color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSuggestions() {
    if (widget.suggestions == null || widget.suggestions!.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            ...widget.suggestions!.take(5).map((suggestion) => ListTile(
              leading: Icon(Icons.history, color: Colors.grey[400], size: 20),
              title: Text(suggestion),
              onTap: () {
                _controller.text = suggestion;
                widget.onChanged(suggestion);
                Navigator.pop(context);
                _focusNode.unfocus();
              },
              trailing: Icon(Icons.north_west, color: Colors.grey[400], size: 16),
            )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
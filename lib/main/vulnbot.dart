// lib/main/vulnbot.dart
// FIX 12: Removed _cardBg — was declared as a static const Color but never
//         referenced anywhere in the widget. Caused an "unused_field" lint warning.
// FIX 13: Removed _borderColor — was identical to _accentRed (same hex value)
//         and was never used directly. Caused a second "unused_field" warning.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../services/vulnbot_fallback.dart';

enum _Sender { user, bot }

class _ChatMessage {
  final String text;
  final _Sender sender;
  final DateTime time;
  final bool isError;

  const _ChatMessage({
    required this.text,
    required this.sender,
    required this.time,
    this.isError = false,
  });
}

class VulnBotScreen extends StatefulWidget {
  final String? missionContext;
  const VulnBotScreen({Key? key, this.missionContext}) : super(key: key);

  @override
  State<VulnBotScreen> createState() => _VulnBotScreenState();
}

class _VulnBotScreenState extends State<VulnBotScreen>
    with TickerProviderStateMixin {
  final ApiService _api = ApiService();
  final List<_ChatMessage> _messages = [];
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isTyping = false;
  bool _isOnline = true;

  late AnimationController _dotController;

  // Design tokens
  static const Color _accentRed  = Color(0xFFE68C8C);
  static const Color _darkBg     = Color(0xFF0A0A0F);
  static const Color _navBg      = Color(0xFF1E1E2A);
  // FIX 12 & 13: removed _cardBg and _borderColor — both were unused fields
  static const Color _userBubble = Color(0xFF7A1C2E);
  static const Color _botBubble  = Color(0xFF1A0D1D);

  static const List<String> _suggestions = [
    'What is SQL Injection?',
    'What is IDOR?',
    'How does UNION attack work?',
    'What is phishing?',
    'What is forced browsing?',
    'How do parameterized queries fix SQLi?',
    'What is spear phishing?',
    'What is Broken Access Control?',
  ];

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _messages.add(_ChatMessage(
      text: "Hey there! I'm **VulnBot** 🤖 — your cybersecurity tutor.\n\n"
          "I can help you understand **SQL Injection**, **Broken Access Control**, "
          "**IDOR**, and **Phishing** topics covered in EthixLabs.\n\n"
          "Ask me anything, or tap a suggestion below!",
      sender: _Sender.bot,
      time: DateTime.now(),
    ));

    setState(() => _isOnline = true);
  }

  @override
  void dispose() {
    _dotController.dispose();
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    _inputCtrl.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _messages.add(_ChatMessage(
        text: query,
        sender: _Sender.user,
        time: DateTime.now(),
      ));
      _isTyping = true;
    });

    _scrollToBottom();

    try {
      final answer = await _api.askVulnBot(
        query,
        missionContext: widget.missionContext,
      );
      setState(() {
        _isTyping = false;
        _isOnline = !answer.startsWith('📡');
        _messages.add(_ChatMessage(
          text: answer,
          sender: _Sender.bot,
          time: DateTime.now(),
        ));
      });
    } catch (_) {
      final offline = VulnBotFallback.getAnswer(query);
      setState(() {
        _isTyping = false;
        _isOnline = false;
        _messages.add(_ChatMessage(
          text: offline ??
              "I'm having trouble connecting. Check your internet and try again.",
          sender: _Sender.bot,
          time: DateTime.now(),
          isError: offline == null,
        ));
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          _buildSuggestions(),
          Expanded(child: _buildMessageList()),
          if (_isTyping) _buildTypingIndicator(),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: _navBg.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(color: _accentRed.withOpacity(0.3), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _accentRed, width: 2),
              color: _darkBg,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/icons/VulnbotAI_LOGO.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.smart_toy_outlined,
                  color: _accentRed,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VulnBot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isOnline
                            ? const Color(0xFF4CAF50)
                            : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _isOnline
                          ? 'Online · AI-Powered'
                          : 'Offline · Cached Answers',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _accentRed.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accentRed.withOpacity(0.4), width: 1),
            ),
            child: const Text(
              'SQLi · BAC · Phishing',
              style: TextStyle(
                color: _accentRed,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _confirmClear,
            child: Icon(
              Icons.refresh_rounded,
              color: Colors.white.withOpacity(0.4),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      height: 42,
      color: _darkBg.withOpacity(0.6),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => _sendMessage(_suggestions[i]),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: _accentRed.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: _accentRed.withOpacity(0.45), width: 1),
            ),
            child: Text(
              _suggestions[i],
              style: const TextStyle(
                color: _accentRed,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (_, i) {
        final msg = _messages[i];
        final isBot = msg.sender == _Sender.bot;
        return Column(
          children: [
            if (i == 0) _buildDateChip(msg.time),
            _buildBubble(msg, isBot),
          ],
        );
      },
    );
  }

  Widget _buildDateChip(DateTime time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Today · ${_formatTime(time)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBubble(_ChatMessage msg, bool isBot) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isBot) ...[
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: _accentRed.withOpacity(0.6), width: 1.5),
                color: _darkBg,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/icons/VulnbotAI_LOGO.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.smart_toy_outlined,
                    color: _accentRed,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () => _copyToClipboard(msg.text),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.76,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: isBot
                      ? (msg.isError
                          ? const Color(0xFF2A0A0A)
                          : _botBubble)
                      : _userBubble,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isBot ? 4 : 16),
                    bottomRight: Radius.circular(isBot ? 16 : 4),
                  ),
                  border: Border.all(
                    color: isBot
                        ? (msg.isError
                            ? Colors.red.withOpacity(0.4)
                            : _accentRed.withOpacity(0.25))
                        : _accentRed.withOpacity(0.6),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormattedText(msg.text),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: isBot
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        if (!isBot) Expanded(child: Container()),
                        Text(
                          _formatTime(msg.time),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 9,
                          ),
                        ),
                        if (!isBot) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.done_all,
                            size: 11,
                            color: _accentRed.withOpacity(0.6),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isBot) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildFormattedText(String text) {
    final parts = text.split(RegExp(r'\*\*'));
    final spans = <TextSpan>[];
    for (int i = 0; i < parts.length; i++) {
      if (i.isOdd) {
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white),
        ));
      } else {
        final lines = parts[i].split('\n');
        for (int j = 0; j < lines.length; j++) {
          if (j > 0) spans.add(const TextSpan(text: '\n'));
          spans.add(TextSpan(
            text: lines[j],
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13.5,
              height: 1.5,
            ),
          ));
        }
      }
    }
    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 54, bottom: 8, top: 2),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _botBubble,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(
                  color: _accentRed.withOpacity(0.25), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _buildDot(i)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _dotController,
      builder: (_, __) {
        final delay = index * 0.33;
        final value = (_dotController.value - delay).clamp(0.0, 1.0);
        final bounce = (value < 0.5 ? value * 2 : (1.0 - value) * 2);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 7,
          height: 7 + (bounce * 5),
          decoration: BoxDecoration(
            color: _accentRed.withOpacity(0.5 + bounce * 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: BoxDecoration(
        color: _navBg.withOpacity(0.97),
        border: Border(
          top: BorderSide(color: _accentRed.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _darkBg.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: _accentRed.withOpacity(0.3), width: 1),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _inputCtrl,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 14),
                      maxLines: 4,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Ask VulnBot anything...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (v) => _sendMessage(v),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessage(_inputCtrl.text),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color:
                    _isTyping ? _accentRed.withOpacity(0.3) : _accentRed,
                shape: BoxShape.circle,
                boxShadow: _isTyping
                    ? []
                    : [
                        BoxShadow(
                          color: _accentRed.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
              ),
              child: Icon(
                _isTyping
                    ? Icons.hourglass_top_rounded
                    : Icons.send_rounded,
                color: _isTyping
                    ? Colors.white.withOpacity(0.4)
                    : Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Message copied to clipboard'),
        backgroundColor: _navBg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _confirmClear() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A0D1D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _accentRed.withOpacity(0.4)),
        ),
        title: const Text('Clear Chat?',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        content: Text(
          'This will remove all messages. VulnBot will greet you again.',
          style: TextStyle(
              color: Colors.white.withOpacity(0.7), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style:
                    TextStyle(color: Colors.white.withOpacity(0.5))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _messages.clear();
                _messages.add(_ChatMessage(
                  text: "Chat cleared! Ask me anything about "
                      "**SQL Injection**, **IDOR**, "
                      "**Broken Access Control**, or **Phishing**.",
                  sender: _Sender.bot,
                  time: DateTime.now(),
                ));
              });
            },
            child: const Text('Clear',
                style: TextStyle(color: _accentRed)),
          ),
        ],
      ),
    );
  }
}
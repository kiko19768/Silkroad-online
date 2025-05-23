import 'package:flutter/material.dart';

enum ChatChannel {
  all,
  map,
  guild,
  party,
  private,
}

class ChatMessage {
  final String senderId;
  final String senderName;
  final String content;
  final ChatChannel channel;
  final DateTime timestamp;
  
  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.channel,
    required this.timestamp,
  });
}

class ChatBox extends StatefulWidget {
  final Function(String) onSendMessage;
  
  const ChatBox({
    Key? key,
    required this.onSendMessage,
  }) : super(key: key);
  
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  ChatChannel _selectedChannel = ChatChannel.all;
  bool _isExpanded = false;
  
  // Sample messages for demonstration
  final List<ChatMessage> _messages = [
    ChatMessage(
      senderId: '1',
      senderName: 'أحمد',
      content: 'مرحباً بالجميع!',
      channel: ChatChannel.all,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      senderId: '2',
      senderName: 'محمد',
      content: 'مرحباً أحمد، كيف حالك؟',
      channel: ChatChannel.all,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    ChatMessage(
      senderId: '3',
      senderName: 'فاطمة',
      content: 'هل يمكن لأحد مساعدتي في مهمة الصحراء؟',
      channel: ChatChannel.map,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    ChatMessage(
      senderId: '4',
      senderName: 'علي',
      content: 'نقابتنا تبحث عن أعضاء جدد!',
      channel: ChatChannel.all,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    ChatMessage(
      senderId: '5',
      senderName: 'زينب',
      content: 'لقد وجدت سيفاً نادراً!',
      channel: ChatChannel.guild,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: _isExpanded ? 300 : 150,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade700,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Chat header
          _buildChatHeader(),
          
          // Chat messages
          Expanded(
            child: _buildChatMessages(),
          ),
          
          // Chat input
          _buildChatInput(),
        ],
      ),
    );
  }
  
  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          // Channel selector
          _buildChannelSelector(),
          
          const Spacer(),
          
          // Expand/collapse button
          IconButton(
            icon: Icon(
              _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
              color: Colors.white,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildChannelSelector() {
    return DropdownButton<ChatChannel>(
      value: _selectedChannel,
      dropdownColor: Colors.black.withOpacity(0.9),
      underline: Container(),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      onChanged: (ChatChannel? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedChannel = newValue;
          });
        }
      },
      items: ChatChannel.values.map<DropdownMenuItem<ChatChannel>>((ChatChannel channel) {
        return DropdownMenuItem<ChatChannel>(
          value: channel,
          child: Text(
            _getChannelName(channel),
            style: TextStyle(
              color: _getChannelColor(channel),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildChatMessageItem(message);
      },
    );
  }
  
  Widget _buildChatMessageItem(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          children: [
            // Channel tag
            TextSpan(
              text: '[${_getChannelName(message.channel)}] ',
              style: TextStyle(
                color: _getChannelColor(message.channel),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // Sender name
            TextSpan(
              text: '${message.senderName}: ',
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // Message content
            TextSpan(
              text: message.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: Row(
        children: [
          // Message input
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك هنا...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          
          // Send button
          IconButton(
            icon: const Icon(
              Icons.send,
              color: Colors.white,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => _sendMessage(_messageController.text),
          ),
        ],
      ),
    );
  }
  
  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;
    
    // Call the callback
    widget.onSendMessage(message);
    
    // Add message to the list
    setState(() {
      _messages.add(ChatMessage(
        senderId: 'self',
        senderName: 'أنت',
        content: message,
        channel: _selectedChannel,
        timestamp: DateTime.now(),
      ));
    });
    
    // Clear the input
    _messageController.clear();
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
  
  String _getChannelName(ChatChannel channel) {
    switch (channel) {
      case ChatChannel.all:
        return 'عام';
      case ChatChannel.map:
        return 'خريطة';
      case ChatChannel.guild:
        return 'نقابة';
      case ChatChannel.party:
        return 'فريق';
      case ChatChannel.private:
        return 'خاص';
    }
  }
  
  Color _getChannelColor(ChatChannel channel) {
    switch (channel) {
      case ChatChannel.all:
        return Colors.white;
      case ChatChannel.map:
        return Colors.green;
      case ChatChannel.guild:
        return Colors.blue;
      case ChatChannel.party:
        return Colors.purple;
      case ChatChannel.private:
        return Colors.orange;
    }
  }
}
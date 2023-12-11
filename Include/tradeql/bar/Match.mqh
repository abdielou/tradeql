#include <Arrays\ArrayObj.mqh>

class Match : public CObject
{
private:
    int start;
    int end;
    bool groupMatch;

public:
    Match(int startIndex = -1, int endIndex = -1, bool isGroupMatch = false) : start(startIndex), end(endIndex), groupMatch(isGroupMatch) {}
    void SetStart(int startIndex) { this.start = startIndex; }
    void SetEnd(int endIndex) { this.end = endIndex; }
    void SetGroupMatch(bool isGroupMatch) { this.groupMatch = isGroupMatch; }
    int GetStart() { return this.start; }
    int GetEnd() { return this.end; }
    bool IsGroupMatch() { return this.groupMatch; }
    bool IsZeroMatch() { return this.start == -1 || this.end == -1; }
};
